<%-- 
    Document   : gerirSubCat
    Created on : 23/01/2026, 16:33:03
    Author     : rafaelacancio
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="estilos.css" rel="stylesheet" type="text/css">
        <title>Gerir SubCategoria</title>
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
                    int cat = Integer.parseInt(categoria);
                    String subCategoria = request.getParameter("subCategoria");
                    String sql = "INSERT INTO tSubcategoria (categoria, subCategoria) " +
                                 "VALUES (?, ?)";

                    PreparedStatement statement = conn.prepareStatement(sql);
                    statement.setInt(1, cat);
                    statement.setString(2, subCategoria);


                    int rowsInserted = statement.executeUpdate();
                    if(rowsInserted > 0){
                        out.println("<h2>Registo inserido com sucesso.</h2>");
                    } else {
                        out.println("<h2>Erro na inserção.</h2>");
                    }
                    statement.close();
                }
                else{
                    String idParam = request.getParameter("id");
                    int id = Integer.parseInt (idParam);

                    Statement stmt = conn.createStatement();
                    String sql = "DELETE FROM tSubcategoria WHERE Id = ?";
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
            </head>
            <body>

        <h1>Gerir SubCategorias</h1>
        <table border="1">
            <tr>
                <th>Id</th>
                <th>Categoria</th>
                <th>SubCategorias</th>
                <th>Ação</th>
            </tr>
            <%
                int num  = 0;
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(""
                        + "jdbc:mysql://localhost:3306/bd_8202", "root", "");
                        Statement stmt = conn.createStatement();
                        
                        ResultSet rs = stmt.executeQuery("SELECT * FROM tSubcategoria, tcategoria WHERE tSubcategoria.categoria = tCategoria.id");
                        while(rs.next()){
                        %>
                        <tr>
                            <td><%= rs.getInt("Id") %></td>
                            <td><%= rs.getString("tCategoria.categoria") %></td>
                            <td><%= rs.getString("tSubcategoria.subCategoria") %></td>
                            <td>
                        <form method="post" action="gerirSubCat.jsp">
                            <input type="hidden" name="acao" value="apagar">
                            <input type="hidden" value="<%= rs.getInt("tSubcategoria.id") %>" name="id">
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
        %>
        <h3>Inserir Subcategoria</h3>
        <form method="post" action="gerirSubCat.jsp">
            <input type="hidden" name="acao" value="inserir">
            Categoria: <select name="categoria">
                <%
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con = DriverManager.getConnection(""
                    + "jdbc:mysql://localhost:3306/bd_8202", "root", "");
                    Statement stm = con.createStatement();
                    ResultSet rs_cat = stm.executeQuery("Select * from tCategoria");
                    while (rs_cat.next()){
                    %>
                    <option value="<%=rs_cat.getInt("id")%>"><%=rs_cat.getString("categoria")%></option>
                    <%
                    }
                    rs_cat.close();
                    stm.close();
                    conn.close();
                    %>
        </select>
        Subcategoria<input type="text" name="subCategoria" size="30">
        <input type="submit" value="Inserir"><br><br>
    </form>
        <a class="bt" href="index.htm" target="_self">Voltar ao menu</a>
    </body>
</html>
