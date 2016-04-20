FROM continuumio/miniconda

RUN apt-get update
RUN conda install -c scitools iris cartopy mo_pack
RUN conda install jupyter notebook=4.0.6

RUN pip install git+git://github.com/SciTools/iris.git@85484be1a52f36913ac7096dc83ae5c77fbef2f6
RUN pip install git+git://github.com/ioam/holoviews.git@3ab4a96f30f2697cf9f578571357db35acb2fae1
RUN pip install git+git://github.com/ioam/param.git@772de0e5ff26de7509e0e14e2b9b8608d5323ae2
RUN pip install git+git://github.com/ioam/paramnb.git@10cf51d6f989ac7055c4a574255cbe3e0ad977e4
RUN pip install git+git://github.com/CubeBrowser/cube-explorer.git@3c574086854a3a3cee03b3d51347b9b0a9ed4c17

# Add Tini
ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# install dashboard
RUN pip install jupyter_dashboards cython
RUN jupyter dashboards install --user --symlink --overwrite
RUN jupyter dashboards activate

VOLUME /notebooks
WORKDIR /notebooks

EXPOSE 8888

ENTRYPOINT ["tini", "--"]
CMD ["jupyter", "notebook", "--no-browser", "--port", "8888", "--ip=*"]
