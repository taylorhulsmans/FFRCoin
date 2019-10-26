DIR=${pwd}
SESSIONNAME=ffdigits
MEMNONIC=$(grep MEMNONIC .env | cut -d '=' -f 2-)
tmux new-session -s $SESSIONNAME \; \
	send-keys 'vi ${DIR}' C-m \; \
	split-window -v \; \
	split-window -v \; \
	send-keys "cd web && npm run serve" C-m \; \
	split-window -h \; \
	send-keys "cd api && npm run serve" C-m \;\
	split-window -h \; \
	send-keys "ganache-cli -b 3 -m ${MEMNONIC}" C-m \; \



