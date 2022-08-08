FROM python:3.10
RUN pip install flask
EXPOSE 8080
WORKDIR /app
COPY ./helloworld.py .
CMD python helloworld.py
