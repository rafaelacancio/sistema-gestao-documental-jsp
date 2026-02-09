<%-- 
    Document   : gerirCat
    Created on : 23/01/2026, 16:32:43
    Author     : rafaelacancio
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="estilos.css" rel="stylesheet" type="text/css">
        <title>Gerir Categorias</title>
            </head>
            <body>
                 <%
            if(request.getMethod().equals("POST")){
                String acao = request.getParameter("acao");
                String url = "jdbc:mysql://localhost:3306/bd_8202";
                String username = "root";
                String password = "";
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection conn = DriverManager.getConnection(url, username, password);
                if (acao.equals("inserir")){
                    String categoria = request.getParameter("categoria");
                    String sql = "INSERT INTO tCategoria (categoria) " +
                                 "VALUES (?)";

                    PreparedStatement statement = conn.prepareStatement(sql);
                    statement.setString(1, categoria);

                    int rowsInserted = statement.executeUpdate();
                    if(rowsInserted > 0){
                        out.println("<h2>Registo inserido com sucesso.</h2>");
                    } else {
                        out.println("<h2>Erro na inserção.</h2>");
                    }
                    statement.close();
                }
                else{
                    String idParam = request.getParameter("Id");
                    int id = Integer.parseInt (idParam);

                    Statement stmt = conn.createStatement();
                    String sql = "DELETE FROM tCategoria WHERE Id = ?";
                    PreparedStatement stm = conn.prepareStatement(sql);
                    stm.setInt(1, id);

                    int rowsDeleted = stm.executeUpdate();
                    if(rowsDeleted > 0){
                        out.println("<h2>Registo apagado com sucesso.</h2>");
                    } else {
                        out.println("<h2>Não existe nenhum registo com esse id.</h2>"+ id);
                    }
                    stm.close();
                }
                conn.close();

            } catch (Exception e) {
                out.println("Ocorreu um erro: " + e.getMessage());
            }
            

        }

            %>
 
        <h1>Gerir Categorias</h1>
        <table>
            <tr>
                <th>Id</th>
                <th>Categoria</th>
                <th>Ação</th>
            </tr>
            <%
                int num  = 0;
                try{
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(""
                        + "jdbc:mysql://localhost:3306/bd_8202", "root", "");
                        Statement stmt = conn.createStatement();
                        
                        ResultSet rs = stmt.executeQuery("SELECT * FROM tCategoria");
                        while(rs.next()){
                        %>
                        <tr>
                            <td><%= rs.getInt("Id") %></td>
                            <td><%= rs.getString("categoria") %></td>
                            <td>
                        <form method="post" action="gerirCat.jsp">
                            <input type="hidden" name="acao" value="apagar">
                            <input type="hidden" value="<%= rs.getInt("Id") %>" name="id">
                            <input type="submit" value="Apagar">                    
                        </form>
                            </td>
                <% num ++; %>
        </tr>
        <%
        }
        %>
        <tr>
            <th colspan="2">Número de registos na BD</th>
            <th><%= num%></th>
        </tr>
        <%
        rs.close();
        stmt.close();
        conn.close();
        } catch (Exception e) {
                out.println("Ocorreu um erro: " + e.getMessage());
        }
        %>
        </table><br><br>
        <h3>Inserir Categorias</h3>
        <form method="post" action="gerirCat.jsp">
        <input type="hidden" name="acao" value="pesquisar"
        <label>Categoria:<input type="text" name="categoria"></label>
        <input type="submit" value="pesquisar"><br><br>
    </form>
        <a class="bt" href="index.htm" target="_self">Voltar ao menu</a>
      
    </body>
</html>
