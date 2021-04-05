# docker build . --progress plain -t myflask
# Validate running the container locally and accessing it via web browser (e.g. expose the web port)
# - docker run -it -p 5000:5000 myflask
# - http://localhost:5000/hello
# Push the image into ECR or hub.docker.com

FROM python
ADD requirements.txt /app/
ADD app.py /app/
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["/app/app.py"]
