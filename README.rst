metaboliic
----------


containerizing AnantharamanLab/METABOLIC
see https://github.com/tin6150/metaboliic.git

start with a docker base
may conver to singularity to run in HPC...

work in progress...



Running Metabolic
=================


TBD



container building
~~~~~~~~~~~~~~~~~~


RUN
===

::

        docker run  -it -v $HOME:/home/tin tin6150/metabolic
        docker exec -it uranus_hertz bash                 # additional terminal into existing running container

		testing intermediary container use:
        docker run  -it -v $HOME:/home/tin tin6150/base4metabolic
        docker run  -it -v $HOME:/home/tin tin6150/perl4metabolic


BUILD
=====

::

        docker build -t tin6150/base4metabolic  -f Dockerfile.base       .  | tee Dockerfile.base.log 
        docker build -t tin6150/perl4metabolic  -f Dockerfile.perl       .  | tee Dockerfile.perl.log 
        docker build -t tin6150/metabolic       -f Dockerfile.metabolic  .  | tee Dockerfile.log 
        -or-
        docker build -t tin6150/metabolic0      -f Dockerfile            .  | tee Dockerfile.monolithic.log 
        -or-
        # alternate starting point, may become independent container if can get docker hub to add new repo...
        docker build -t tin6150/bioperl         -f Dockerfile.bioperl    .  | tee Dockerfile.bioperl.log 

        THEN
        sudo /opt/singularity-2.6/bin/singularity build --writable metabolic_b1219a.img Singularity 2>&1  | tee singularity_build.log
        # (see additional comments in the Singularity file)




