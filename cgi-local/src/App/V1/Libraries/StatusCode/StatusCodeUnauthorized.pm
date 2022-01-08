
package V1::StatusCodeUnauthorized;
{
    sub response {
        $message = $_[0];

        return {
            "statusCode" => "401",
            "code" => "401 Unauthorized",
            "message" => $message
        };
    }
}
1;