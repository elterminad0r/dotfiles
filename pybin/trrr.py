#!/usr/bin/env python3

#   __
# _/  |_ _______ _______ _______
# \   __\\_  __ \\_  __ \\_  __ \
#  |  |   |  | \/ |  | \/ |  | \/
#  |__|   |__|    |__|    |__|
# FIGMENTIZE: trrr

"""
Like tr, but it understands Unicode, by way of being a Python 3 program, and it
has built in a fairly large number of fancy looking unicode things.

The translation specs are passed through str.format, with access to a namespace
providing a number of alphabets, which are currently just latin letters with
font variations. This means you can use format specs like

`trrr '{upper}' '{lower}'` to lowercase some text, or

`trrr '{bold}{thin}' '{thin}{bold}'` to swap bold and thin letters.

If the length of the interpolated `to_spec` is a factor of that of `from_spec`,
`to_spec` will be replicated to restore parity. Otherwise, the specs should
generally have the same length. This little trick makes it easy to write  very
much surjective, non-injective mappings, like making everything smallcaps:

`trrr '{letters}' '{sc}'`, or

`trrr '{upper}{sc}' '{nm_u}' | trrr '{lower}' '{nm_l}'` to make everything
normal.

I have personally defined several aliases with "common" translations that I find
"useful".

You can also supply four further optional arguments. The first two are sets to
be subtracted from the specs, the second two are sets of characters for the
specs to be intersected with. This is probably useful for something, although
I've not quite figured out what it might be.

This script also acts as a module, which can be used to grab useful predefined
alphabets, or use some of the utility functions like `upper()` and `lower()`
"""

import sys
import smartparse as argparse

# Big start gained by scraping from here:
# https://www.compart.com/en/unicode/decomposition/%3Cfont%3E
# let s = ''; for (let e of document.querySelectorAll("p.text,div.text")) {s += e.innerHTML.trim()}; print(s)

# TODO: use some of these
# 𝚨𝚩𝚪𝚫𝚬𝚭𝚮𝚯𝚰𝚱𝚲𝚳𝚴𝚵𝚶𝚷𝚸𝚹𝚺𝚻𝚼𝚽𝚾𝚿𝛀𝛁
# 𝛂𝛃𝛄𝛅𝛆𝛇𝛈𝛉𝛊𝛋𝛌𝛍𝛎𝛏𝛐𝛑𝛒𝛓𝛔𝛕𝛖𝛗𝛘𝛙𝛚𝛛𝛜𝛝𝛞𝛟𝛠𝛡
# 𝛢𝛣𝛤𝛥𝛦𝛧𝛨𝛩𝛪𝛫𝛬𝛭𝛮𝛯𝛰𝛱𝛲𝛳𝛴𝛵𝛶𝛷𝛸𝛹𝛺𝛻
# 𝛼𝛽𝛾𝛿𝜀𝜁𝜂𝜃𝜄𝜅𝜆𝜇𝜈𝜉𝜊𝜋𝜌𝜍𝜎𝜏𝜐𝜑𝜒𝜓𝜔𝜕𝜖𝜗𝜘𝜙𝜚𝜛𝜜
# 𝜝𝜞𝜟𝜠𝜡𝜢𝜣𝜤𝜥𝜦𝜧𝜨𝜩𝜪𝜫𝜬𝜭𝜮𝜯𝜰𝜱𝜲𝜳𝜴𝜵
# 𝜶𝜷𝜸𝜹𝜺𝜻𝜼𝜽𝜾𝜿𝝀𝝁𝝂𝝃𝝄𝝅𝝆𝝇𝝈𝝉𝝊𝝋𝝌𝝍𝝎𝝏𝝐𝝑𝝒𝝓𝝔𝝕
# 𝝖𝝗𝝘𝝙𝝚𝝛𝝜𝝝𝝞𝝟𝝠𝝡𝝢𝝣𝝤𝝥𝝦𝝧𝝨𝝩𝝪𝝫𝝬𝝭𝝮𝝯
# 𝝰𝝱𝝲𝝳𝝴𝝵𝝶𝝷𝝸𝝹𝝺𝝻𝝼𝝽𝝾𝝿𝞀𝞁𝞂𝞃𝞄𝞅𝞆𝞇𝞈𝞉𝞊𝞋𝞌𝞍𝞎𝞏
# 𝞐𝞑𝞒𝞓𝞔𝞕𝞖𝞗𝞘𝞙𝞚𝞛𝞜𝞝𝞞𝞟𝞠𝞡𝞢𝞣𝞤𝞥𝞦𝞧𝞨𝞩
# 𝞪𝞫𝞬𝞭𝞮𝞯𝞰𝞱𝞲𝞳𝞴𝞵𝞶𝞷𝞸𝞹𝞺𝞻𝞼𝞽𝞾𝞿𝟀𝟁𝟂𝟃𝟄𝟅𝟆𝟇𝟈𝟉
# ℏℓℹℼℽℾℿ⅀ⅅⅆⅇⅈⅉ
# ﬠﬡﬢﬣﬤﬥﬦﬧﬨ﬩
# 𝚤𝚥
# 𝟊𝟋

# Some of these may well look a lot like normal ASCII letters, depending on what
# font you're using. However they are not, these are all Unicode letters, with
# explicit semantics about their typesetting.
alphabets = {
    "nm_u": "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "nm_l": "abcdefghijklmnopqrstuvwxyz",
    "nm_n": "0123456789",
    "bf_u": "𝐀𝐁𝐂𝐃𝐄𝐅𝐆𝐇𝐈𝐉𝐊𝐋𝐌𝐍𝐎𝐏𝐐𝐑𝐒𝐓𝐔𝐕𝐖𝐗𝐘𝐙",
    "bf_l": "𝐚𝐛𝐜𝐝𝐞𝐟𝐠𝐡𝐢𝐣𝐤𝐥𝐦𝐧𝐨𝐩𝐪𝐫𝐬𝐭𝐮𝐯𝐰𝐱𝐲𝐳",
    "bf_n": "𝟎𝟏𝟐𝟑𝟒𝟓𝟔𝟕𝟖𝟗",
    "it_u": "𝐴𝐵𝐶𝐷𝐸𝐹𝐺𝐻𝐼𝐽𝐾𝐿𝑀𝑁𝑂𝑃𝑄𝑅𝑆𝑇𝑈𝑉𝑊𝑋𝑌𝑍",
    "it_l": "𝑎𝑏𝑐𝑑𝑒𝑓𝑔ℎ𝑖𝑗𝑘𝑙𝑚𝑛𝑜𝑝𝑞𝑟𝑠𝑡𝑢𝑣𝑤𝑥𝑦𝑧",
    "bi_u": "𝑨𝑩𝑪𝑫𝑬𝑭𝑮𝑯𝑰𝑱𝑲𝑳𝑴𝑵𝑶𝑷𝑸𝑹𝑺𝑻𝑼𝑽𝑾𝑿𝒀𝒁",
    "bi_l": "𝒂𝒃𝒄𝒅𝒆𝒇𝒈𝒉𝒊𝒋𝒌𝒍𝒎𝒏𝒐𝒑𝒒𝒓𝒔𝒕𝒖𝒗𝒘𝒙𝒚𝒛",
    "scr_u": "𝒜ℬ𝒞𝒟ℰℱ𝒢ℋℐ𝒥𝒦ℒℳ𝒩𝒪𝒫𝒬ℛ𝒮𝒯𝒰𝒱𝒲𝒳𝒴𝒵",
    "scr_l": "𝒶𝒷𝒸𝒹ℯ𝒻ℊ𝒽𝒾𝒿𝓀𝓁𝓂𝓃ℴ𝓅𝓆𝓇𝓈𝓉𝓊𝓋𝓌𝓍𝓎𝓏",
    "scb_u": "𝓐𝓑𝓒𝓓𝓔𝓕𝓖𝓗𝓘𝓙𝓚𝓛𝓜𝓝𝓞𝓟𝓠𝓡𝓢𝓣𝓤𝓥𝓦𝓧𝓨𝓩",
    "scb_l": "𝓪𝓫𝓬𝓭𝓮𝓯𝓰𝓱𝓲𝓳𝓴𝓵𝓶𝓷𝓸𝓹𝓺𝓻𝓼𝓽𝓾𝓿𝔀𝔁𝔂𝔃",
    "frk_u": "𝔄𝔅ℭ𝔇𝔈𝔉𝔊ℌℑ𝔍𝔎𝔏𝔐𝔑𝔒𝔓𝔔ℜ𝔖𝔗𝔘𝔙𝔚𝔛𝔜ℨ",
    "frk_l": "𝔞𝔟𝔠𝔡𝔢𝔣𝔤𝔥𝔦𝔧𝔨𝔩𝔪𝔫𝔬𝔭𝔮𝔯𝔰𝔱𝔲𝔳𝔴𝔵𝔶𝔷",
    "frb_u": "𝕬𝕭𝕮𝕯𝕰𝕱𝕲𝕳𝕴𝕵𝕶𝕷𝕸𝕹𝕺𝕻𝕼𝕽𝕾𝕿𝖀𝖁𝖂𝖃𝖄𝖅",
    "frb_l": "𝖆𝖇𝖈𝖉𝖊𝖋𝖌𝖍𝖎𝖏𝖐𝖑𝖒𝖓𝖔𝖕𝖖𝖗𝖘𝖙𝖚𝖛𝖜𝖝𝖞𝖟",
    "sns_u": "𝖠𝖡𝖢𝖣𝖤𝖥𝖦𝖧𝖨𝖩𝖪𝖫𝖬𝖭𝖮𝖯𝖰𝖱𝖲𝖳𝖴𝖵𝖶𝖷𝖸𝖹",
    "sns_l": "𝖺𝖻𝖼𝖽𝖾𝖿𝗀𝗁𝗂𝗃𝗄𝗅𝗆𝗇𝗈𝗉𝗊𝗋𝗌𝗍𝗎𝗏𝗐𝗑𝗒𝗓",
    "sns_n": "𝟢𝟣𝟤𝟥𝟦𝟧𝟨𝟩𝟪𝟫",
    "snb_u": "𝗔𝗕𝗖𝗗𝗘𝗙𝗚𝗛𝗜𝗝𝗞𝗟𝗠𝗡𝗢𝗣𝗤𝗥𝗦𝗧𝗨𝗩𝗪𝗫𝗬𝗭",
    "snb_l": "𝗮𝗯𝗰𝗱𝗲𝗳𝗴𝗵𝗶𝗷𝗸𝗹𝗺𝗻𝗼𝗽𝗾𝗿𝘀𝘁𝘂𝘃𝘄𝘅𝘆𝘇",
    "snb_n": "𝟬𝟭𝟮𝟯𝟰𝟱𝟲𝟳𝟴𝟵",
    "sni_u": "𝘈𝘉𝘊𝘋𝘌𝘍𝘎𝘏𝘐𝘑𝘒𝘓𝘔𝘕𝘖𝘗𝘘𝘙𝘚𝘛𝘜𝘝𝘞𝘟𝘠𝘡",
    "sni_l": "𝘢𝘣𝘤𝘥𝘦𝘧𝘨𝘩𝘪𝘫𝘬𝘭𝘮𝘯𝘰𝘱𝘲𝘳𝘴𝘵𝘶𝘷𝘸𝘹𝘺𝘻",
    "sbi_u": "𝘼𝘽𝘾𝘿𝙀𝙁𝙂𝙃𝙄𝙅𝙆𝙇𝙈𝙉𝙊𝙋𝙌𝙍𝙎𝙏𝙐𝙑𝙒𝙓𝙔𝙕",
    "sbi_l": "𝙖𝙗𝙘𝙙𝙚𝙛𝙜𝙝𝙞𝙟𝙠𝙡𝙢𝙣𝙤𝙥𝙦𝙧𝙨𝙩𝙪𝙫𝙬𝙭𝙮𝙯",
    "tt_u": "𝙰𝙱𝙲𝙳𝙴𝙵𝙶𝙷𝙸𝙹𝙺𝙻𝙼𝙽𝙾𝙿𝚀𝚁𝚂𝚃𝚄𝚅𝚆𝚇𝚈𝚉",
    "tt_l": "𝚊𝚋𝚌𝚍𝚎𝚏𝚐𝚑𝚒𝚓𝚔𝚕𝚖𝚗𝚘𝚙𝚚𝚛𝚜𝚝𝚞𝚟𝚠𝚡𝚢𝚣",
    "tt_n": "𝟶𝟷𝟸𝟹𝟺𝟻𝟼𝟽𝟾𝟿",
    # TODO: x is faked here. Apparently smallcaps X doesn't even exist,
    #       according to Wikipedia.
    "sc": "ᴀʙᴄᴅᴇꜰɢʜɪᴊᴋʟᴍɴᴏᴘꞯʀꜱᴛᴜᴠᴡxʏᴢ",
    "bb_u": "𝔸𝔹ℂ𝔻𝔼𝔽𝔾ℍ𝕀𝕁𝕂𝕃𝕄ℕ𝕆ℙℚℝ𝕊𝕋𝕌𝕍𝕎𝕏𝕐ℤ",
    "bb_l": "𝕒𝕓𝕔𝕕𝕖𝕗𝕘𝕙𝕚𝕛𝕜𝕝𝕞𝕟𝕠𝕡𝕢𝕣𝕤𝕥𝕦𝕧𝕨𝕩𝕪𝕫",
    "bb_n": "𝟘𝟙𝟚𝟛𝟜𝟝𝟞𝟟𝟠𝟡",
    # https://jkirchartz.com/demos/fake_russian_generator.html
    "cyrillic_fake": "ДБҪDԐҒGҤЇJҜLԠЙФPQЯSГЦVШӼҰZ"}

all_lower = []
all_upper = []

for alph in alphabets:
    if alph.endswith("_u"):
        all_upper.append(alph)
        all_lower.append("{}_l".format(alph.rstrip("_u")))

all_letters = [alph for alph in alphabets if not alph.endswith("_n")]
all_numbers = [alph for alph in alphabets if alph.endswith("_n")]

alphabets["lower"] = "".join(alphabets[a] for a in all_lower)
alphabets["upper"] = "".join(alphabets[a] for a in all_upper)
alphabets["letters"] = "".join(alphabets[a] for a in all_letters)
alphabets["numbers"] = "".join(alphabets[a] for a in all_numbers)

all_bold = """bf_u bf_l bf_n bi_u bi_l scb_u scb_l frb_u frb_l snb_u snb_l
              snb_n sbi_u sbi_l""".split()
all_thin = """nm_u nm_l nm_n it_u it_l scr_u scr_l frk_u frk_l sns_u sns_l
              sns_n sni_u sni_l""".split()

alphabets["bold"] = "".join(alphabets[a] for a in all_bold)
alphabets["thin"] = "".join(alphabets[a] for a in all_thin)

all_italic = "it_u it_l bi_u bi_l sni_u sni_l sbi_u sbi_l".split()
all_straight = "nm_u nm_l bf_u bf_l sns_u sns_l snb_u snb_l".split()

alphabets["italic"] = "".join(alphabets[a] for a in all_italic)
alphabets["straight"] = "".join(alphabets[a] for a in all_straight)

def summarise_alphabets(alphabets):
    """
    Produce a summary of alphabets
    """
    # determine longest key
    w = max(map(len, alphabets))
    for k, alph in alphabets.items():
        print("{:{w}}: {}".format(k, alph, w=w))

class ListAction(argparse._HelpAction):
    """
    Action that must override any other parsing to produce a list and exit,
    which is actually very similar functionality to -h, so we reappropriate
    HelpAction.
    """
    def __call__(self, parser, namespace, values, option_string=None):
        summarise_alphabets(alphabets)
        sys.exit()

def get_args():
    """
    Parse argv
    """
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("-l", "--list", action=ListAction,
            help="""Do not translate, instead produce a list of available
                    alphabets.""")
    parser.add_argument("from_spec",
            help="Spec for the set of characters to be translated")
    parser.add_argument("to_spec",
            help="Spec for the set of characters to be translated to")
    parser.add_argument("from_spec_sub", nargs="?", default="",
            help="Spec to subtract from from_spec")
    parser.add_argument("to_spec_sub", nargs="?", default="",
            help="Spec to subtract from to_spec")
    parser.add_argument("from_spec_inter", nargs="?", default="",
            help="Spec to intersect from_spec with")
    parser.add_argument("to_spec_inter", nargs="?", default="",
            help="Spec to intersect to_spec with")
    args = parser.parse_args()
    if not args.to_spec:
        parser.error("to_spec should be nonempty.")
    return args

upper_trans = str.maketrans(alphabets["lower"], alphabets["upper"])
lower_trans = str.maketrans(alphabets["upper"], alphabets["lower"])

def upper(s):
    """
    Even more unicode-supporting uppercasing function.

    It only acts as a humble wrapper to str.upper(), moreover giving str.upper
    precedence. This is because str.upper is already basically quite good at
    multilingual casing, and I only care about the weird typesetting-y
    codepoints for entirely nefarious purposes.
    """
    return s.translate(upper_trans).upper()

def lower(s):
    """
    Even more unicode-supporting lowercasing function. See above
    """
    return s.translate(lower_trans).lower()

class YesMan:
    """
    Dummy class that replies yes to any membership queries, used for the
    default type of intersection.
    """
    def __contains__(self, item):
        return True

def trrr(from_spec, to_spec, from_spec_sub, to_spec_sub,
         from_spec_inter, to_spec_inter, alphabets):
    """
    Perform the actual translation, interpreting the specs using the alphabets.
    """
    from_sub_set = set(from_spec_sub.format(**alphabets))
    to_sub_set = set(to_spec_sub.format(**alphabets))
    from_inter_set = set(from_spec_inter.format(**alphabets))
    to_inter_set = set(to_spec_inter.format(**alphabets))
    if not from_inter_set:
        from_inter_set = YesMan()
    if not to_inter_set:
        to_inter_set = YesMan()
    from_full = "".join(c for c in from_spec.format(**alphabets)
            if c not in from_sub_set and c in from_inter_set)
    to_full = "".join(c for c in to_spec.format(**alphabets)
            if c not in to_sub_set and c in to_inter_set)
    if len(from_full) % len(to_full) == 0:
        to_full = to_full * (len(from_full) // len(to_full))
    else:
        print("from_spec should resolve to a length that is a "
              "multiple of that of to_spec",
                file=sys.stderr)
        sys.exit(1)
    trans = str.maketrans(from_full, to_full)
    for line in sys.stdin:
        sys.stdout.write(line.translate(trans))

if __name__ == "__main__":
    args = get_args()
    trrr(args.from_spec, args.to_spec, args.from_spec_sub, args.to_spec_sub,
         args.from_spec_inter, args.from_spec_sub, alphabets)
