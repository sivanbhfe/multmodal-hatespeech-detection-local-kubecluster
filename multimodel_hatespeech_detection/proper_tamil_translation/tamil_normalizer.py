from indic_transliteration import sanscript
from indic_transliteration.sanscript import transliterate
import sys
import os
from pathlib import Path

from symspellpy import SymSpell, Verbosity
# initialize once
sym_spell = SymSpell(max_dictionary_edit_distance=2, prefix_length=7)


PACKAGE_ROOT = Path(os.path.abspath(os.path.dirname(__file__))).parent.parent
sys.path.append(str(PACKAGE_ROOT))


# tamil_dict="D:\\AI_Doctorate\\HateSpeechModel_Draft\\MultimodelHateSpeechDetection_related\\tamil\\tamil_words.txt"
empty_tamil_dict= PACKAGE_ROOT / "multimodel_hatespeech_detection" / "symspell_dictionary" / "symspell_dictionary.txt"
with open(empty_tamil_dict, "r", encoding="utf-8") as f:
    sym_spell.load_dictionary(f, term_index=0, count_index=1)

def transliterate_to_tamil(text: str) -> str:
    try:
        tamil_text = transliterate(text, sanscript.ITRANS, sanscript.TAMIL)
        return tamil_text
    except Exception as e:
        raise RuntimeError(f"Error in transliteration: {e}")

def correct_tamil_spelling(sentence: str) -> str:
    # words = utf8.get_letters(sentence)
    corrected_words = []
    for word in sentence.split():
        # Create a spell checker instance
        suggestions = sym_spell.lookup(word, Verbosity.TOP, max_edit_distance=2)
        suggestions = list(suggestions)
        if suggestions:
            corrected_words.append(suggestions[0].term)  # choose first suggestion
        else:
            corrected_words.append(word)
    return " ".join(corrected_words)