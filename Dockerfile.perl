# Dockerfile for creating Metabolic in a container, part 2: perl and cpan packages
# see https://github.com/AnantharamanLab/METABOLIC


#FROM r-base:3.6.2
#FROM tin6150/base4metabolic
MAINTAINER Tin (at) LBL.gov

#RUN  echo "Building ... this isn't likely working yet" 

RUN touch    _TOP_DIR_OF_CONTAINER_  ;\
    echo "begining docker build process at " | tee -a _TOP_DIR_OF_CONTAINER_  ;\
    date | TZ=PST8PDT tee -a       _TOP_DIR_OF_CONTAINER_ ;\

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

    echo 'last line of RUN block in Dockerbuild without continuation :)'


RUN     cd / \
  && touch _TOP_DIR_OF_CONTAINER_  \
  && TZ=PST8PDT date  >> _TOP_DIR_OF_CONTAINER_  \
  && echo  "Dockerfile 2019.1218 1618"  >> _TOP_DIR_OF_CONTAINER_   \
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
