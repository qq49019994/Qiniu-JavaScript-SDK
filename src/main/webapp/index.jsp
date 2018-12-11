<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.qiniu.util.Auth" %>
<%
    String accessKey = "";
    String secretKey = "";
    String bucket = "";
    Auth auth = Auth.create(accessKey, secretKey);
    String upToken = auth.uploadToken(bucket).trim();
%>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <title></title>
    <script src="https://cdn.bootcss.com/jquery/3.3.1/jquery.min.js"></script>
    <script type="text/javascript" src='https://unpkg.com/qiniu-js@2.5.3/dist/qiniu.min.js'></script>
</head>
<body>
<form method="post" enctype="multipart/form-data" id="form" action="upload">
    <div id="box2">
        <input class="file-input" type="file" id="select2"/>
    </div>
</form>
</body>
<script>
    $("#select2").unbind("change").bind("change", function () {
        var domain = "";
        var config = {
            useCdnDomain: true,
            disableStatisticsReport: false,
            retryCount: 6,
            region: qiniu.region.z1
        };
        var putExtra = {
            fname: "",
            params: {},
            mimeType: null
        };
        var observer = {
            next(res) {
                console.log("已上传：" + res.total.percent);
            },
            error(err) {
                console.log("上传发生问题：" + err);
            },
            complete(res) {
                console.log("上传成功，文件下载地址：" + domain + res.key);
            }
        }
        var file = this.files[0];
        var key = file.name;
        var observable = qiniu.upload(file, key, "<%=upToken%>", putExtra, config);
        observable.subscribe(observer);
    })


</script>
</html>
