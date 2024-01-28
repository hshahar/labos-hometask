FROM python:3.9-alpine
WORKDIR /app
COPY . /app
RUN apk add --no-cache build-base && \
    pip install --no-cache-dir requests && \
    apk del build-base && pip install -r requirements.txt
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

ENTRYPOINT [ "python" ]
CMD ["app.py"]
