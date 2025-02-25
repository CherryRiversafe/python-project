FROM python:3.9.21-alpine3.21
WORKDIR '/project-1'

COPY requirements.txt .
RUN pip install -r ./requirements.txt

COPY  api.py .

EXPOSE 5000

CMD ["python", "api.py"]