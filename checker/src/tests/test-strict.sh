#!/bin/sh
echo "Following test cases should show \e[6;30;42maccepted\e[0m:"
./test.py ./strict strict-ac

echo
echo "Following test cases should show '\e[1;91mOn line x column x, read x, expected x\e[0m': "
./test.py ./strict character-diff

echo
echo "Following test cases should show '\e[1;33mToo long on line x.\e[0m': "
./test.py ./strict toolong

echo
echo "Following test cases should show '\e[1;36mToo short on line x.\e[0m': "
./test.py ./strict tooshort

echo
echo "Following test cases should show '\e[1;35mToo many or too few lines.\e[0m': "
./test.py ./strict toomany
./test.py ./strict toofew

echo
echo "Following test cases should not pass for some reason (except wrong character): "
./test.py ./strict noip-ac

echo
echo "Following test cases should show wrong output format, but always not too long or too short on line 65: "
./test.py ./strict overflow-bug