
package V1::StatusCodeNotFound;
{
    sub response {
        $message = $_[0];

        return {
            "statusCode" => "404",
            "code" => "404 Not Found",
            "message" => $message
        };
    }
}
1;