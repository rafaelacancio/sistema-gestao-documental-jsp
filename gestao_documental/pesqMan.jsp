<%-- 
    Document   : pesqMan
    Created on : 30/01/2026, 17:44:00
    Author     : rafaelacancio
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="estilos.css" rel="stylesheet" type="text/css">
        <title>Gestão de Manuais</title>
    </head>
    <body>
        <h1>Pesquisar Manuais</h1>
        <%
            if (request.getMethod().equals("POST")) {
                String acao = request.getParameter("acao");
                String url = "jdbc:mysql://localhost:3306/bd_8202";
                String username = "root";
                String password = "";
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(url, username, password);

                    if ("pesquisar".equalsIgnoreCase(acao)) {
                        String texto = request.getParameter("texto");
        %>

        <h3>Pesquisa de <b><i><%= texto %></i></b> nos manuais</h3>
        <table border="1" class="table table-striped">
            <thead>
                <tr>
                    <th>Id</th>
                    <th>Nome</th>
                    <th>ISBN</th>
                    <th>Descrição</th>
                    <th>Tamanho</th>
                    <th>Foto</th>
                    <th>Ficheiro</th>
                    <th>SubCategorias</th>
                    <th>Ação</th>
                </tr>
            </thead>
            <tbody>
                <%
                    int num = 0;
                    try {
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(
                                "SELECT * FROM tDocumento WHERE nome LIKE '%" + texto + "%'");
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("Id") %></td>
                    <td><%= rs.getString("nome") %></td>
                    <td><%= rs.getString("isbn") %></td>
                    <td><%= rs.getString("descricao") %></td>
                    <td><%= rs.getString("tamanho") %></td>
                    <td><img width="100px" src="<%= rs.getString("foto") %>"></td>
                    <td><a target="_self" href="<%= rs.getString("ficheiro") %>">Download</a></td>
                    <td><%= rs.getInt("idSubCat") %></td>
                    <td>
                        <form method="post" action="pesqMan.jsp">
                            <input type="hidden" name="acao" value="apagar">
                            <input type="hidden" name="id" value="<%= rs.getInt("Id") %>">
                            <input type="submit" value="Apagar">
                        </form>
                    </td>
                </tr>
                <%
                            num++;
                        }
                %>
                <tr>
                    <td colspan="7">Registos de manuais</td>
                    <td style="text-align: right;"><%= num %></td>
                </tr>
                <%
                        rs.close();
                        stmt.close();
                    } catch (Exception e) {
                        out.println("Ocorreu um erro: " + e.getMessage());
                    }
                %>
            </tbody>
        </table>
        <br><br>

        <%
                    } else {
                        String idParam = request.getParameter("id");
                        int id = Integer.parseInt(idParam);
                        String sql = "DELETE FROM tDocumento WHERE Id = ?";
                        PreparedStatement stm = conn.prepareStatement(sql);
                        stm.setInt(1, id);

                        int rowsDeleted = stm.executeUpdate();
                        if (rowsDeleted > 0) {
                            out.println("<h2>Registo apagado com sucesso.</h2>");
                        } else {
                            out.println("<h2>Não existe nenhum registo com esse id.</h2>" + id);
                        }
                        stm.close();
                    }
                    conn.close();
                } catch (Exception e) {
                    out.println("Ocorreu um erro: " + e.getMessage());
                }
            } else {
        %>

        <h3>Listagem de Manuais</h3>
        <table border="1" class="table table-striped">
            <thead>
                <tr>
                    <th>Id</th>
                    <th>Nome</th>
                    <th>ISBN</th>
                    <th>Descrição</th>
                    <th>Tamanho</th>
                    <th>Foto</th>
                    <th>Ficheiro</th>
                    <th>SubCategorias</th>
                    <th>Ação</th>
                </tr>
            </thead>
            <tbody>
                <%
                    int num = 0;
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(
                                "jdbc:mysql://localhost:3306/bd_8202", "root", "");
                        Statement stmt = conn.createStatement();

                        ResultSet rs = stmt.executeQuery("SELECT * FROM tDocumento");
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("Id") %></td>
                    <td><%= rs.getString("nome") %></td>
                    <td><%= rs.getString("isbn") %></td>
                    <td><%= rs.getString("descricao") %></td>
                    <td><%= rs.getString("tamanho") %></td>
                    <td><img width="100px" src="<%= rs.getString("foto") %>"></td>
                    <td><a target="_self" href="<%= rs.getString("ficheiro") %>">Download</a></td>
                    <td><%= rs.getInt("idSubCat") %></td>
                    <td>
                        <form method="post" action="pesqMan.jsp">
                            <input type="hidden" name="acao" value="apagar">
                            <input type="hidden" name="id" value="<%= rs.getInt("Id") %>">
                            <input type="submit" value="Apagar">
                        </form>
                    </td>
                </tr>
                <%
                            num++;
                        }
                %>
                <tr>
                    <td colspan="7">Registos de manuais</td>
                    <td style="text-align: right;"><%= num %></td>
                </tr>
                <%
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("Ocorreu um erro: " + e.getMessage());
                    }
                %>
            </tbody>
        </table>

        <%
            }
        %>

        <h3>Pesquisar Manuais</h3>
        <form method="post" action="pesqMan.jsp">
            <input type="hidden" name="acao" value="pesquisar">
            <label>Manual:
                <input type="text" name="texto">
            </label>
            <input type="submit" value="Pesquisar"><br><br>
        </form>

        <a class="bt" href="index.htm" target="_self">Voltar ao menu</a>
    </body>
</html>

