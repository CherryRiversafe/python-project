#FROM python:3.9.21-alpine3.21
public.ecr.aws/lambda/python:3.7

#WORKDIR '/project-1'
COPY . ${LAMBDA_TASK_ROOT}

COPY requirements.txt .
RUN pip install -r requirements.txt --target "${LAMBDA_TASK_ROOT}"

COPY  api.py .

#EXPOSE 5000

#CMD ["python", "api.py"]
CMD ["api.handler"]