# Importing Dependencies
from fastapi import FastAPI
from pydantic import BaseModel
import uvicorn
import sys
import os
from pathlib import Path

# # Adding the below path to avoid module not found error
PACKAGE_ROOT = Path(os.path.abspath(os.path.dirname(__file__))).parent
sys.path.append(str(PACKAGE_ROOT))

# # Then perform import
# from prediction_model.config import config
from multimodel_hatespeech_detection.extract_caption.extractcaption import extract_caption
from multimodel_hatespeech_detection.proper_tamil_translation import tamil_normalizer
from multimodel_hatespeech_detection.image_preprocessing import caption_removal

# classification_pipeline = load_pipeline(config.MODEL_NAME)

app = FastAPI()

#Perform parsing
class image_path_details(BaseModel):
    image_path_details: str
    output_path_details: str

@app.get('/')
def index():
    return {'message': 'Welcome to Loan Prediction App'}
    
# defining the function which will make the prediction using the data which the user inputs
@app.post('/extractcaption')
def extracted_caption(image_path: image_path_details):
    imagepath =image_path.model_dump()
    caption_text = extract_caption(imagepath["image_path_details"])

    caption_text = tamil_normalizer.transliterate_to_tamil(caption_text)
    caption_text = tamil_normalizer.correct_tamil_spelling(caption_text)

    return ("Extracted caption:",caption_text)

@app.post('/removecaption')
def remove_caption(image_path: image_path_details):
    imagepath =image_path.model_dump()
    caption_removal.remove_text_ocr(imagepath["image_path_details"], imagepath["output_path_details"])
    return ("Status:","Caption successfully removed")

if __name__ == '__main__':
    uvicorn.run("main:app", host="0.0.0.0",port=8005,reload=False)