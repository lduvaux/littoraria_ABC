#!/bin/bash
echo "slash N1 N2 N3 N4 m12 m21 m23 m32 m34 m43 t1 t2 t3" > all_tbs_parameters.txt
grep "//" ms-ali_interspe-mig.txt >> all_tbs_parameters.txt
