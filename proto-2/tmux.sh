DIR=${pwd}
SESSIONNAME=ffdigits
MEMNONIC=$(grep MEMNONIC .env | cut -d '=' -f 2-)
BLOCKSPEED=0
GASLIMIT=8000000
tmux new-session -s $SESSIONNAME \; \
	send-keys 'vi ${DIR}' C-m \; \
	split-window -v \; \
	split-window -v \; \
	send-keys "cd web && npm run serve" C-m \; \
	split-window -h \; \
	send-keys "cd api && npm run serve" C-m \;\
	split-window -h \; \
	send-keys "nvm use 12 && ganache-cli -b ${BLOCKSPEED}  --gasLimit=${GASLIMIT}  -m ${MEMNONIC}" C-m \; \



