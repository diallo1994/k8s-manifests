helm install --name testpostgres --namespace test -f values.yml bitnami/postgresql

export POSTGRES_PASSWORD=$(kubectl get secret --namespace test testpostgres-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)

kubectl run testpostgres-postgresql-client --rm --tty -i --restart='Never' \
    --namespace test --image docker.io/bitnami/postgresql:11.10.0-debian-10-r24 \
    --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host testpostgres-postgresql \
    -U postgres -d index -p 5432

kubectl port-forward --namespace test svc/testpostgres-postgresql 5432:5432