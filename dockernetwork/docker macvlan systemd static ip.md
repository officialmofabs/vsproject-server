
### features

- working macvlan with docker
- systemd network devices
- each container can reach the whole nework (full routing)
- `docker-compose.yml` example with static ipv4 on macvlan
- if no ip defined, container get a ip within `192.168.155.192/27`


### macvlan
```bash
docker network create \
                    -d macvlan \
                    -o parent=eth0 \
                    --subnet=192.168.155.0/24 \
                    --gateway=192.168.155.0 \
                    --ip-range 192.168.155.192/27 \
                    macvlan # the name
```