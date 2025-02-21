if (( RANDOM % 2 )); then
    (exit 33) && true
else
    (exit 0) && true
fi

