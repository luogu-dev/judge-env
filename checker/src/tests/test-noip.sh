#!/bin/sh
echo "Following test cases should show \e[6;30;42maccepted\e[0m:"
./test.py ./noip strict-ac
./test.py ./noip noip-ac

echo
echo "Following test cases should show '\e[1;91mOn line x column x, read x, expected x\e[0m': "
./test.py ./noip character-diff

echo
echo "Following test cases should show '\e[1;33mToo long on line x.\e[0m': "
./test.py ./noip toolong

echo
echo "Following test cases should show '\e[1;36mToo short on line x.\e[0m': "
./test.py ./noip tooshort

echo
echo "Following test cases should show '\e[1;35mToo many or too few lines.\e[0m': "
./test.py ./noip toomany
./test.py ./noip toofew

echo
echo "Following test cases should show \e[6;30;42maccepted\e[0m, and always not too long or too short on line 65: "
./test.py ./noip overflow-bug