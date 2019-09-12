DIR=${pwd}
SESSIONNAME=ffdigits
MEMNONIC=$(grep MEMNONIC .env | cut -d '=' -f 2-)
tmux new-session -s $SESSIONNAME \; \
	send-keys 'vi ${DIR}' C-m \; \
	split-window -v \; \
	split-window -v \; \
	send-keys "cd www/web && npm run serve" C-m \; \
	split-window -h \; \
	send-keys "cd www/api && npm run serve" C-m \;\
	split-window -h \; \
	send-keys "ganache-cli -m ${MEMNONIC}" C-m \; \



