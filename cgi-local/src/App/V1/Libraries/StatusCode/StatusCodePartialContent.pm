
package V1::StatusCodePartialContent;
{
    sub response {
        $message = $_[0];

        return {
            "statusCode" => "206",
            "code" => "206 Partial Content",
            "message" => $message
        };
    }
}
1;