# Main Dockerfile for creating Metabolic in a container
# see https://github.com/AnantharamanLab/METABOLIC
 

#FROM cgrlab/sambamba
#FROM conda/miniconda3  # Debian, not ubuntu, can't find R!
#FROM ubuntu:19.04
FROM r-base:3.6.2
MAINTAINER Tin@LBL.gov

#RUN  echo "Building ... this isn't likely working yet" 


# seeding the container with sambamba 
# which cgrlab has it as ubuntu:14.04
# may want to rebuild from scratch...
# ubuntu has many more of the dependencies as .deb already

# conda installer maybe tricky, base off that instead.  Debian base.

RUN touch    _TOP_DIR_OF_CONTAINER_  ;\
    echo "begining docker build process at " | tee -a _TOP_DIR_OF_CONTAINER_  ;\
    date | TZ=PST8PDT tee -a       _TOP_DIR_OF_CONTAINER_ ;\
    echo "installing packages via apt"       | tee -a _TOP_DIR_OF_CONTAINER_  ;\
    apt-get update ;\
    # ubuntu:
    apt-get --quiet install perl-base r-base hmmer prodigal bamtools python git file wget gzip bash tcsh zsh less vim bc tmux screen xterm ;\
    echo '========================================================'   ;\
    echo "installing packages wget/sh"  | tee -a _TOP_DIR_OF_CONTAINER_   ;\
    date | TZ=PST8PDT tee -a      _TOP_DIR_OF_CONTAINER_              ;\
    echo '========================================================'   ;\
    mkdir -p Downloads &&  cd Downloads ;\
    wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda3.sh  ;\
    bash miniconda3.sh -b -p /opt/conda ;\
		echo 'export PATH="${PATH}:/opt/conda/bin"'                       >> /etc/bashrc    ;\
    echo 'export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/opt/conda/lib"' >> /etc/bashrc    ;\

    wget --quiet https://github.com/biod/sambamba/releases/download/v0.7.1/sambamba-0.7.1-linux-static.gz ;\
    gunzip sambamba-0.7.1-linux-static.gz  ;\
    cd .. ;\
    echo '==================================================================' ;\
    echo '==================================================================' ;\
    echo "installing packages via conda"  | tee -a _TOP_DIR_OF_CONTAINER_     ;\
    date | TZ=PST8PDT tee -a                       _TOP_DIR_OF_CONTAINER_     ;\
    echo '==================================================================' ;\
    echo '==================================================================' ;\
    /opt/conda/bin/conda install bwa coverm ;\

    echo '==================================================================' ;\
    echo "installing perl/cpan packages"  | tee -a _TOP_DIR_OF_CONTAINER_     ;\
    date | TZ=PST8PDT tee -a                       _TOP_DIR_OF_CONTAINER_     ;\
    echo '==================================================================' ;\
		PERL_MM_USE_DEFAULT=1 cpan -i Data::Dumper                                ;\
		PERL_MM_USE_DEFAULT=1 perl -MCPAN -e cpann "install POSIX qw(strftime)"   ;\
		PERL_MM_USE_DEFAULT=1 cpan -i Excel::Writer::XLSX ;\    
		PERL_MM_USE_DEFAULT=1 cpan -i Getopt::Long ;\    
		PERL_MM_USE_DEFAULT=1 cpan -i Statistics::Descriptive ;\
		PERL_MM_USE_DEFAULT=1 perl -MCPAN -e cpann "Array::Split qw(split_by split_into)" ;\
		PERL_MM_USE_DEFAULT=1 cpan -i Bio::SeqIO ;\
		PERL_MM_USE_DEFAULT=1 cpan -i Bio::Perl  ;\
		PERL_MM_USE_DEFAULT=1 cpan -i Bio::Tools::CodonTable ;\
		PERL_MM_USE_DEFAULT=1 cpan -i Carp ;\


    echo '==================================================================' ;\
    echo '==================================================================' ;\
    echo '==================================================================' ;\
    echo "installing packages cran packages" | tee -a _TOP_DIR_OF_CONTAINER_  ;\
    date | TZ=PST8PDT tee -a      _TOP_DIR_OF_CONTAINER_                      ;\
    echo '==================================================================' ;\
    echo '==================================================================' ;\
    echo '==================================================================' ;\
    Rscript --quiet -e 'install.packages("diagram",    repos = "http://cran.us.r-project.org")'    ;\
    Rscript --quiet -e 'install.packages("forcats",    repos = "http://cran.us.r-project.org")'    ;\
    Rscript --quiet -e 'install.packages("digest",     repos = "http://cran.us.r-project.org")'    ;\
    Rscript --quiet -e 'install.packages("htmltools",  repos = "http://cran.us.r-project.org")'    ;\
    Rscript --quiet -e 'install.packages("rmarkdown",  repos = "http://cran.us.r-project.org")'    ;\
    Rscript --quiet -e 'install.packages("reprex",     repos = "http://cran.us.r-project.org")'    ;\
    Rscript --quiet -e 'install.packages("tidyverse",  repos = "http://cran.us.r-project.org")'    ;\
    Rscript --quiet -e 'install.packages("stringi",    repos = "http://cran.us.r-project.org")'    ;\
    Rscript --quiet -e 'install.packages("ggthemes",   repos = "http://cran.us.r-project.org")'    ;\
    Rscript --quiet -e 'install.packages("ggalluvial", repos = "http://cran.us.r-project.org")'    ;\
    Rscript --quiet -e 'install.packages("reshape2",   repos = "http://cran.us.r-project.org")'    ;\
    Rscript --quiet -e 'install.packages("ggraph",     repos = "http://cran.us.r-project.org")'    ;\


    echo '========================================================'   ;\
    echo '========================================================'   ;\
    echo "compiling packages"  | tee -a _TOP_DIR_OF_CONTAINER_        ;\
    date | TZ=PST8PDT tee -a            _TOP_DIR_OF_CONTAINER_        ;\
    echo '========================================================'   ;\
    echo '========================================================'   ;\


    cd /Downloads ;\
    git clone --quiet https://github.com/AnantharamanLab/METABOLIC.git ;\
    cd METABOLIC ;\
    git log > metabolics.git.log ;\

    make 2>&1 | tee make.log.rst ;\
    echo $? > _METABOLIC_BUILD_END_ ;\

    echo 'last line of RUN block in Dockerbuild without continuation :)'


RUN     cd / \
  && touch _TOP_DIR_OF_CONTAINER_  \
  && TZ=PST8PDT date  >> _TOP_DIR_OF_CONTAINER_  \
  && echo  "Dockerfile 2019.1218 1416"  >> _TOP_DIR_OF_CONTAINER_   \
  && echo  "Grand Finale"

#- ENV TZ America/Los_Angeles  
ENV TZ America/Los_Angeles 
# ENV TZ likely changed/overwritten by container's /etc/csh.cshrc
#ENV DOCKERFILE Dockerfile[.cmaq]
# does overwrite parent def of ENV DOCKERFILE
ENV TEST_DOCKER_ENV     this_env_will_be_avail_when_container_is_run_or_exec
ENV TEST_DOCKER_ENV_2   Can_use_ADD_to_make_ENV_avail_in_build_process
ENV TEST_DOCKER_ENV_REF https://vsupalov.com/docker-arg-env-variable-guide/#setting-env-values
# but how to append, eg add to PATH?

#ENTRYPOINT ["cat", "/Downloads/netcdf-fotran-4.4.5/_END_BUILD_NETCDF_"]
#ENTRYPOINT ["cat", "/Downloads/CMAQ/_CMAQ_BUILD_END_"]
#ENTRYPOINT ["cat", "/_TOP_DIR_OF_CONTAINER_"]
ENTRYPOINT [ "/bin/bash" ]
# if no defined ENTRYPOINT, default to bash inside the container
# parent container defined tcsh.
# can also run with exec bash to get shell:
# docker exec -it tin6150/metabolic -v $HOME:/home/tin  bash 
# careful not to cover /home/username (for this container)
