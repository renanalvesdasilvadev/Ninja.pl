
package V1::StatusCodeForbidden;
{
    sub response {
        $message = $_[0];

        return {
            "statusCode" => "403",
            "code" => "403 Forbidden",
            "message" => $message
        };
    }
}
1;