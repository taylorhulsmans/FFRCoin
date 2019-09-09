DIR=${pwd}
SESSIONNAME=ffdigits
MEMNONIC=$(grep MEMNONIC .env | cut -d '=' -f 2-)
tmux new-session -s $SESSIONNAME \; \
	send-keys 'vi ${DIR}' C-m \; \
	split-window -v \; \
	send-keys "" \; \
	split-window -v \; \
	send-keys "ganache-cli -m ${MEMNONIC}" C-m \; \



