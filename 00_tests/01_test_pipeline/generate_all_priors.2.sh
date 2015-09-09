#!/bin/bash
echo "slash n1 n2 n3 n4 N1 N2 N3 N4 m12 m21 m23 m32 m34 m43 t1 t2 t3" > all_tbs_parameters.txt
grep "//" ms-ali_interspe-mig.txt >> all_tbs_parameters.txt
