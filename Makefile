app = cs
src_d = src
inc_d = include
src = $(wildcard $(src_d)/*.c)
obj = $(patsubst %.c, %.o, $(src))

CC = gcc
DFLAGS = -Wall -g -DDEBUG -lsqlite3
CFLAGS = -I$(inc_d) $(DFLAGS)


$(app): $(obj) client
	$(CC) $(obj) -o $@ $(CFLAGS)


ifneq ($(MAKECMDGOALS), clean)
sinclude $(src:.c=.d)

%.d: %.c
	@set -e; \
	rm -f $@; \
	$(CC) -MM $(CFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[:]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$
endif


%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS)


.PHONY: client clean
client:
	@cd cc && make
clean:
	-rm $(src_d)/*.o $(src_d)/*.d $(app)
	@cd cc && make clean
