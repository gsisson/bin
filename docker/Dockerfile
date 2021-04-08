# Build the image locally
# - docker build . --progress plain -t flaskdemo
# Validate running the container locally and accessing it via web browser (e.g. expose the web port)
# - docker run -it -p 5000:5000 flaskdemo
# - http://localhost:5000/hello
# Push the image into ECR
# - create the repository in ECR via console
# - use the commands shown in console
#   - aws ecr get-login-password | docker login --username AWS --password-stdin ACCT.dkr.ecr.REGION.amazonaws.com
#   - docker tag REPONAME:latest ACCT.dkr.ecr.REGION.amazonaws.com/REPONAME:latest

FROM python
ADD requirements.txt /app/
ADD app.py /app/
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["/app/app.py"]
