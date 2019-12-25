# Dockerfile for creating Metabolic in a container, part 2: perl and cpan packages

# Metabolic source: https://github.com/AnantharamanLab/METABOLIC
# Dockerfile github: https://github.com/tin6150/metabolic/blob/master/Dockerfile.perl



#FROM r-base:3.6.2
FROM tin6150/base4metabolic
MAINTAINER Tin (at) LBL.gov

#RUN  echo "Building ... this isn't likely working yet" 

#ARG TZ="America/Denver"
ARG TZ="America/Los_Angeles"
ARG DEBIAN_FRONTEND=noninteractive

RUN touch    _TOP_DIR_OF_CONTAINER_  ;\
    echo "begining docker build process at " | tee -a _TOP_DIR_OF_CONTAINER_  ;\
    date | TZ=PST8PDT tee -a       _TOP_DIR_OF_CONTAINER_ ;\
    test -d /opt/gitrepo  || mkdir -p /opt/gitrepo        ;\
    cd      /opt/gitrepo  ;\
    test -d /opt/gitrepo/metabolic  || git clone https://github.com/tin6150/metabolic.git  ;\
    cd      /opt/gitrepo/metabolic &&  git pull && cd -   ;\
    cd      /  ;\

    echo '==================================================================' ;\
    echo "installing perl/cpan packages"  | tee -a _TOP_DIR_OF_CONTAINER_     ;\  
    date | TZ=PST8PDT tee -a                       _TOP_DIR_OF_CONTAINER_     ;\  
    echo '==================================================================' ;\
    # TBD, future adopt tin6150/bioperl use of external shell scripts to do more complete install
    export PERL_MM_USE_DEFAULT=1                                              ;\
    # cpan -f is force, -i is install.  Bio::Perl is a beast and won't install :(
    PERL_MM_USE_DEFAULT=1 cpan -fi Data::Dumper                               ;\
    PERL_MM_USE_DEFAULT=1 perl -MCPAN -e cpann "install POSIX qw(strftime)"   ;\  
    PERL_MM_USE_DEFAULT=1 cpan -fi Excel::Writer::XLSX ;\    
    PERL_MM_USE_DEFAULT=1 cpan -fi Getopt::Long ;\    
    PERL_MM_USE_DEFAULT=1 cpan -fi Statistics::Descriptive ;\
    PERL_MM_USE_DEFAULT=1 perl -MCPAN -e cpann "Array::Split qw(split_by split_into)" ;\
    PERL_MM_USE_DEFAULT=1 cpan -fi Bio::SeqIO ;\
    # found these dependencies when tried to run METABOLIC-G.pl
    PERL_MM_USE_DEFAULT=1 cpan -fi Array/Split.pm ;\
    PERL_MM_USE_DEFAULT=1 cpan -fi Data/OptList.pm  ;\  
    PERL_MM_USE_DEFAULT=1 cpan -fi Parallel/ForkManager.pm  ;\  

    echo '==================================================================' ;\
    echo '==================================================================' ;\
    echo "installing Bio::Perl packages"  | tee -a _TOP_DIR_OF_CONTAINER_     ;\  
    echo '==================================================================' ;\
    PERL_MM_USE_DEFAULT=1 cpan -fi Bio::Perl  ;\  
    echo $? > bioperl.exit.code ;\
    echo '==================================================================' ;\
    echo "done install Bio::Perl packages"  | tee -a _TOP_DIR_OF_CONTAINER_     ;\  
    echo '==================================================================' ;\
    echo '==================================================================' ;\
    PERL_MM_USE_DEFAULT=1 cpan -fi Bio::Tools::CodonTable ;\
    PERL_MM_USE_DEFAULT=1 cpan -fi Carp ;\
    PERL_MM_USE_DEFAULT=1 cpan -fi Text::Levenshtein::XS Text::Levenshtein::Damerau::XS Text::Levenshtein Text::Levenshtein::Damerau::PP ;\
    echo $? > cpan.exit.code ;\
    #PERL_MM_USE_DEFAULT=1 cpan -i perldoc ;\
    #perldoc -t perllocal    ;\
    cpan -a > cpan.list.out ;\
    # last count = 1565, but no match for Bio
    # with -f count = 1900+, many match Bio

    echo 'Ending.  Last line of RUN block in Dockerbuild without continuation :)'


RUN     cd / \
  && touch _TOP_DIR_OF_CONTAINER_  \
  && TZ=PST8PDT date  >> _TOP_DIR_OF_CONTAINER_  \
  && echo  "Dockerfile.perl 2019.1225.1225"  >> _TOP_DIR_OF_CONTAINER_   \
  && echo  "Grand Finale"

# ENV TZ America/Los_Angeles  
# ENV TZ could be changed/overwritten by container's /etc/csh.cshrc
ENV DOCKERFILE Dockerfile.perl # DOES overwrite parent def of ENV DOCKERFILE
ENV TEST_DOCKER_ENV_2   Can_use_ADD_to_make_ENV_avail_in_build_process
ENV TEST_DOCKER_ENV_REF https://vsupalov.com/docker-arg-env-variable-guide/#setting-env-values
ENV DOCKER_MANTABOLIC_PERL "CPAN packages, including bioperl"
# but how to append, eg add to PATH?

ENTRYPOINT [ "/bin/bash" ]
# if no defined ENTRYPOINT, default to bash inside the container
