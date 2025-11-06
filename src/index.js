export default {
  async fetch(request) {
    const allowedMethods = ['GET', 'HEAD', 'OPTIONS'];
    const headers = {
      'Allow': allowedMethods.join(', '),
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': allowedMethods.join(', '),
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      'Access-Control-Max-Age': '86400',
    };

    // Handle `OPTIONS` request method
    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204, headers });
    }

    // Check if method is allowed
    if (!allowedMethods.includes(request.method)) {
      return new Response('Method Not Allowed', {
        status: 405,
        headers,
      });
    }

    // Respond to GET or HEAD
    return new Response('added bindings', {
      status: 200,
      headers: {
        ...headers,
        'Content-Type': 'text/plain; charset=UTF-8',
      },
    });
  },
};
