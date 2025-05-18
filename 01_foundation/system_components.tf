locals {
  system_components = {
    traefik = {
      pg_databases = []
      storage = [
        {
          storage_name = "certificates"
          size         = 1
          access_mode  = "ReadWriteOnce"
        },
      ]
      authentication = {
        name = "Traefik"
        type = "proxy"

        description = "Traefik Ingress Controller Dashboord"
        group       = "Admin Panel"
      }
    }
  }
}
