<%-- 
    Document   : inserirCat
    Created on : 23/01/2026, 16:51:26
    Author     : rafaelacancio
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inserir Categorias</title>
    <link href="estilos.css" rel="stylesheet" type="text/css">

    <% if ("POST".equalsIgnoreCase(request.getMethod())) { %>
        <meta http-equiv="refresh" content="2;url=index.jsp">
    <% } %>
</head>
<body>

<h1>Inserir Categoria</h1>

<%
if ("POST".equalsIgnoreCase(request.getMethod())) {

    String categoria = request.getParameter("categoria");
    String url = "jdbc:mysql://localhost:3306/bd_8202";
    String username = "root";
    String password = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(url, username, password);

        String sql = "INSERT INTO tCategoria (categoria) VALUES (?)";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setString(1, categoria);

        int rowsInserted = statement.executeUpdate();

        if (rowsInserted > 0) {
            out.println("<h2>Registo inserido com sucesso.</h2>");
        } else {
            out.println("<h2>Erro na inserção.</h2>");
        }

        statement.close();
        conn.close();

    } catch (Exception e) {
        out.println("<h2>Ocorreu um erro: " + e.getMessage() + "</h2>");
    }

} else {
%>

<form method="post" action="inserirCat.jsp">
    <label>
        Categoria:
        <input type="text" name="categoria" size="20" placeholder="Coloque a categoria">
    </label><br><br>
    <input type="submit" value="Inserir">
</form>

<%
}
%>

<a class="bt" href="index.htm">Voltar ao menu</a>

</body>
</html>
