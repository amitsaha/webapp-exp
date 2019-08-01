echo "
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: nginx-image-ingress-$CI_ENVIRONMENT_SLUG
  namespace: $KUBE_NAMESPACE
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    kubernetes/ingress.class: nginx
spec:
 rules:
 - host: $CI_ENVIRONMENT_SLUG.test-nginx.info
   http:
     paths:
     - path: /*
       backend:
         serviceName: nginxsvc1
         servicePort: 80
"
