# use the Docker Python base image
FROM python

# set maintainer
LABEL maintainer "alexander.donn@mobiledgex.com"

# set a health check
HEALTHCHECK --interval=5s \
            --timeout=5s \
            CMD curl -f http://127.0.0.1:8000 || exit 1

#Copy in the index.html page
COPY index.html . 

# tell docker what port to expose
EXPOSE 8000

CMD ["python3", "-m", "http.server", "8000"]