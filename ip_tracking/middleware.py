import datetime
from django.http import HttpResponseForbidden
from django.utils.deprecation import MiddlewareMixin
from ip2geotools.databases.noncommercial import DbIpCity
from ip_tracking.models import RequestLog, BlockedIP

class RequestLoggingMiddleware(MiddlewareMixin):
    """
    Middleware that logs every incoming request (IP address, timestamp, path, geolocation)
    and blocks requests from blacklisted IPs.
    """

    def process_request(self, request):
        ip_address = self.get_client_ip(request)

        # 1. Block IPs from BlockedIP table
        if BlockedIP.objects.filter(ip_address=ip_address).exists():
            return HttpResponseForbidden("Your IP address is blocked.")

        # 2. Fetch geolocation
        country, city = self.get_geolocation(ip_address)

        # 3. Log the request
        RequestLog.objects.create(
            ip_address=ip_address,
            path=request.path,
            timestamp=datetime.datetime.now(),
            country=country,
            city=city
        )

    def get_client_ip(self, request):
        """Get the client's real IP address."""
        x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
        if x_forwarded_for:
            return x_forwarded_for.split(',')[0]
        return request.META.get('REMOTE_ADDR')

    def get_geolocation(self, ip_address):
        """Get country and city using ip2geotools. Returns ('Unknown', 'Unknown') if failed."""
        try:
            response = DbIpCity.get(ip_address, api_key='free')
            return response.country, response.city
        except Exception:
            return "Unknown", "Unknown"

