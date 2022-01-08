
package V1::StatusCodeBadRequest;
{

    sub response {
        $message = $_[0];

        return {
            "statusCode" => "400",
            "code" => "400 Bad Request",
            "message" => $message
        };
    }
}
1;