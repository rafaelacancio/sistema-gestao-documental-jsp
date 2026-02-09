<%-- 
    Document   : pesqSubCat
    Created on : 06/02/2026, 00:44:59
    Author     : Utilizador
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="estilos.css" rel="stylesheet" type="text/css">
        <title>Gestão de SubCategorias</title>
    </head>
    <body>
        <h1>Pesquisar SubCategorias</h1>
        <%
            if (request.getMethod().equals("POST")) {
                String acao = request.getParameter("acao");
                String url = "jdbc:mysql://localhost:3306/bd_8202";
                String username = "root";
                String password = "";
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(url, username, password);

                    if ("pesquisar".equals(acao)) {
                        String texto = request.getParameter("texto");
        %>

        <h3>Pesquisa de <b><i><%= texto %></i></b> SubCategorias</h3>
        <table border="1" class="table table-striped">
            <thead>
                <tr>
                    <th>Id</th>
                    <th>Categoria</th>
                    <th>subCategoria</th>
                    <th>Ação</th>
                </tr>    
            </thead>
            <tbody>
                <%
                    int num = 0;
                    try {
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(
                                "SELECT * FROM tsubcategoria WHERE subCategoria LIKE '%" + texto + "%'");
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("Id") %></td>
                    <td><%= rs.getInt("categoria") %></td>
                    <td><%= rs.getString("subCategoria") %></td>
                    <td>
                        <form method="post" action="pesqSubCat.jsp">
                            <input type="hidden" name="acao" value="apagar">
                            <input type="hidden" value="<%= rs.getInt("Id") %>" name="id">
                            <input type="submit" value="Apagar">                    
                        </form>
                    </td>
                </tr>
                <%
                            num++;
                        }
                %>
                <tr>
                    <td colspan="2">Registos da pesquisa</td>
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
                        String sql = "DELETE FROM tsubcategoria WHERE Id = ?";
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

        <h3>Listagem de Subcategorias</h3>
        <table border="1" class="table table-striped">
            <thead>
                <tr>
                    <th>Id</th>
                    <th>Categoria</th>
                    <th>Subcategoria</th>
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

                        ResultSet rs = stmt.executeQuery("SELECT * FROM tsubcategoria");
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("Id") %></td>
                    <td><%= rs.getInt("categoria") %></td>
                    <td><%= rs.getString("subcategoria") %></td>
                    <td>
                        <form method="post" action="pesqSubCat.jsp">
                            <input type="hidden" name="acao" value="apagar">
                            <input type="hidden" value="<%= rs.getInt("Id") %>" name="id">
                            <input type="submit" value="Apagar">                    
                        </form>
                    </td>
                </tr>
                <%
                            num++;
                        }
                %>
                <tr>
                    <td colspan="2">Registos da pesquisa</td>
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

        <h3>Pesquisar Sucategorias</h3>
        <form method="post" action="pesqSubCat.jsp">
            <input type="hidden" name="acao" value="pesquisar">
            <label>Subcategoria:
                <input type="text" name="texto">
            </label>
            <input type="submit" value="pesquisar"><br><br>
        </form>

        <a class="bt" href="index.htm" target="_self">Voltar ao menu</a>
    </body>
</html>
