
package V1::StatusCodeInternalError;
{
    sub response {
        $message = $_[0];

        return {
            "statusCode" => "500",
            "code" => "500 Internal Server Error",
            "message" => $message
        };
    }
}
1;