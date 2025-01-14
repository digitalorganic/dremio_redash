FROM redash/redash:8.0.0.b32245

USER root
# RUN useradd --create-home redash

ENV REDASH_BASE_PATH=/app
ENV DRIVER_VERSION=1.5.4.1002
ENV REDASH_ADDITIONAL_QUERY_RUNNERS='redash.query_runner.python,redash.query_runner.dremio_odbc'

RUN apt-get update  &&\
apt-get install -y alien unixodbc unixodbc-dev python3-pip python-pip vim &&\
wget --no-check-certificate "https://fileserv.do.co.th/static/files/dremio/2022/dremio-odbc-${DRIVER_VERSION}-1.x86_64.rpm" -O /dremio-odbc-${DRIVER_VERSION}-1.x86_64.rpm &&\
alien -i --scripts /dremio-odbc-${DRIVER_VERSION}-1.x86_64.rpm &&\
rm -f /dremio-odbc-${DRIVER_VERSION}-1.x86_64.rpm &&\
pip3 install pyodbc pandas &&\
pip install pyodbc pandas &&\
wget -O $REDASH_BASE_PATH/client/dist/images/db-logos/dremio_odbc.png "https://raw.githubusercontent.com/udaykrishna/dremio_redash/master/dremio_odbc.png" &&\
wget -O $REDASH_BASE_PATH/client/app/assets/images/db-logos/dremio_odbc.png "https://raw.githubusercontent.com/udaykrishna/dremio_redash/master/dremio_odbc.png"

COPY dremio_odbc.py /app/redash/query_runner/dremio_odbc.py

RUN apt-get clean && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

RUN chown -R redash /app
USER redash
ENTRYPOINT ["/app/bin/docker-entrypoint"]
CMD ["server"]