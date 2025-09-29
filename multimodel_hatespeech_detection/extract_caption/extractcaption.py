from PIL import Image
import pytesseract
pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

def extract_caption(image_path: str, lang: str = "eng+tam") -> str:
    """
    Extracts caption text from an image using OCR.

    Args:
        image_path (str): Path to the image file.
        lang (str): Language code for OCR (default: "eng").

    Returns:
        str: Extracted text from the image.
    """
    try:
        img = Image.open(image_path)
        caption_text = pytesseract.image_to_string(img, lang=lang)
        print("Extracted caption:", caption_text)
        return caption_text.strip()
    except Exception as e:
        raise RuntimeError(f"Error extracting caption: {e}")