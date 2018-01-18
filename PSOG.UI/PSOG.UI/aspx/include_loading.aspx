
<div id="divprogressbar"
	style="position: absolute; width: 100%; height: 100%; left: 0px; top: 0px; background-color:White; filter: alpha (     opacity =     100 ); z-index: 50000">
	<div style="text-align: center; padding-top: 200px">
		<table align="center" border="1" width="37%" cellspacing="0"
			cellpadding="4" style="border-collapse: collapse; background-color:White;border:0px;" >
			<tr>
				<td style="font-size: 12px; line-height: 200%; height:100px; background-color:White;border:0px;" align="center">					
					<%--<img src="../resource/img/rolling.gif" alt=""/>--%>
				</td>
			</tr>
			<tr>
				<td style="font-size: 13px;color:rgb(227,108,2); font-family: 宋体; background-color:White;border:0px;" height="16px"
					align="center">
					数据载入中,请稍等片刻...
				</td>
			</tr>
			
		</table>
	</div>
</div>
<script>
    //: 判断网页是否加载完成
    document.onreadystatechange = function () {
       // if (document.readyState == "complete") {
            document.getElementById('divprogressbar').style.display = 'none';
        //}
    }
</script>
