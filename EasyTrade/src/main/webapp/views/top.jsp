<%@ page import="java.time.*, javax.servlet.http.*, java.time.temporal.ChronoUnit" %>
<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%
    boolean loggedIn = (session != null && session.getAttribute("userId") != null);
    String userName = (loggedIn && session.getAttribute("userName") != null) ? (String) session.getAttribute("userName") : "";
    long remainingTimeMillis = 0;

    if (loggedIn) {
        long lastAccess = session.getLastAccessedTime();
        long now = System.currentTimeMillis();
        long maxInactive = session.getMaxInactiveInterval(); // 초
        remainingTimeMillis = (lastAccess + (maxInactive * 1000L)) - now;
        if (remainingTimeMillis < 0) remainingTimeMillis = 0;
    }
%>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="main.jsp">EasyTrade</a>
    <div class="d-flex align-items-center">
      <% if (loggedIn) { %>
        <span id="sessionTimer" class="me-3 text-muted small">
          안녕하세요, <%= userName %>님 | 남은 시간: 계산중...
        </span>
        <form action="extendSession.jsp" method="post" class="me-3">
            <button type="submit" class="btn btn-outline-primary btn-sm">세션 연장</button>
        </form>
        <a class="nav-link me-3" href="editUser.jsp">정보수정</a>
        <a class="nav-link" href="logout.jsp">로그아웃</a>
      <% } else { %>
        <a class="nav-link me-3" href="signup.jsp">회원가입</a>
        <a class="nav-link" href="login.jsp">로그인</a>
      <% } %>
    </div>
  </div>
</nav>

<% if (loggedIn) { %>
<script>
  let remainingTime = <%= remainingTimeMillis / 1000 %>; // 초 단위

  function updateTimer() {
    if (remainingTime <= 0) {
      document.getElementById("sessionTimer").innerText = "세션 만료됨";
      return;
    }
    let min = Math.floor(remainingTime / 60);
    let sec = Math.floor(remainingTime % 60);
    document.getElementById("sessionTimer").innerText =
      "안녕하세요, <%= userName %>님 | 남은 시간: " + min + "분 " + sec + "초";
    remainingTime--;
  }

  updateTimer();
  setInterval(updateTimer, 1000); // 1초마다 갱신
</script>
<% } %>
