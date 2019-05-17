# azkaban-solo
Azkaban solo container. Contains H2+Executor+UI all-in-one

## Usage

* Create a docker-compose.yml

```yml
version: '3.7'

services:

  azkaban-solo:
    image: flaviostutz/azkaban-solo
    ports:
      - 8081:8081
      - 8443:8443
```

* Run with 'docker-compose up'

* Open browser at http://localhost:8081
  * Default login/password is azkaban/azkaban

