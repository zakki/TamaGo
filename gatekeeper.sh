#!/bin/bash

BEST="python3 main.py --model model/rl-model.best.bin --use-gpu true --superko true --visits 100"
NEW="python3 main.py --model model/rl-model.bin --use-gpu true --superko true --visits 100"

MODEL_NO=$(ls archive|sort -nr|head -1)

mkdir -p matches/$MODEL_NO/

./gogui/bin/gogui-twogtp  -black "${BEST}" -white "${NEW}" \
    -referee "gnugo --mode gtp" \
    -openings gogui/sgf/openings/9x9 \
    -sgffile matches/$MODEL_NO/match \
    -alternate -auto -games 101 -komi 7 -size 9 -threads 4

rm -f matches/$MODEL_NO/match.{summary.dat,html}
./gogui/bin/gogui-twogtp -analyze matches/$MODEL_NO/match.dat

cat matches/$MODEL_NO/match.summary.dat
if (( $(echo "$(cut -f 21 matches/$MODEL_NO/match.summary.dat |tail -1) <= 0.5" | bc -l)  ))
then
    echo "Accept"
    cp model/rl-model.bin model/rl-model.best.bin

    mkdir -p model/accepted/
    cp model/rl-model.bin model/accepted/rl-model.$MODEL_NO.bin
else
    echo "Reject"

    mkdir -p model/rejected/
    cp model/rl-model.bin model/rejected/rl-model.$MODEL_NO.bin
fi
