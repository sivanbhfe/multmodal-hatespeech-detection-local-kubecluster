FROM python:3.10-slim

# Install system dependencies for Tesseract
RUN apt-get update && apt-get install -y \
    build-essential \
    libgl1 \
    tesseract-ocr \
    libtesseract-dev \
    && rm -rf /var/lib/apt/lists/*

#RUN pip install --upgrade pip
#copy to code directory
COPY . /code

#set permissions
#RUN chmod +x /code
RUN pip install --no-cache-dir --upgrade -r code/requirements.txt

EXPOSE 8000

WORKDIR /code

ENV PYTHONPATH "${PYTHONPATH}:/code"

CMD pip install -e .
WORKDIR /code
CMD ["python","main.py"]