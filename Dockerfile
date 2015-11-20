FROM python:2

# Prep the environment
RUN apt-get update && apt-get -y install \
  texlive-latex-recommended \
  texlive-fonts-recommended \
  texlive-latex-extra \
  doxygen \
  dvipng \
  graphviz

# Install readthedocs (bits as of Nov 20 2015)
RUN mkdir /www
WORKDIR /www

COPY ./files/readthedocs.org-master.tar.gz ./readthedocs.org-master.tar.gz
RUN tar -zxvf readthedocs.org-master.tar.gz
RUN mv ./readthedocs.org-master ./readthedocs.org

WORKDIR /www/readthedocs.org

# Fix broken media paths
# Copy files from readthedocs to media to make themes and JavaScript work
RUN mkdir ./media/static
RUN cp -a ./readthedocs/static/* ./media/static/
RUN cp -a ./readthedocs/core/static/* ./media/static/


# Install the required Python packages
RUN pip install -r requirements.txt

# Install a higher version of requests to fix an SSL issue
RUN pip install requests==2.6.0

# Override the default settings
COPY ./files/local_settings.py ./readthedocs/settings/local_settings.py

# Deploy the database
RUN python ./manage.py migrate

# Create a super user
RUN echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@localhost', 'admin')" | python ./manage.py shell

# Load test data
RUN python ./manage.py loaddata test_data

# Install supervisord
RUN pip install supervisor
ADD files/supervisord.conf /etc/supervisord.conf

VOLUME /www/readthedocs.org

ENV RTD_PRODUCTION_DOMAIN 'localhost:8000'

CMD ["supervisord"]