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


BUILD
=====

::

        docker build -t tin6150/base4metabolic  -f Dockerfile.base       .  | tee Dockerfile.base.log 
        docker build -t tin6150/perl4metabolic  -f Dockerfile.perl       .  | tee Dockerfile.perl.log 
        docker build -t tin6150/metabolic       -f Dockerfile.metabolic  .  | tee Dockerfile.log 
        -or-
        docker build -t tin6150/metabolic0      -f Dockerfile            .  | tee Dockerfile.monolithic.log 




