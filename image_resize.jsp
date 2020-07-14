<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@ page import="java.io.*"%>
<%@ page import="javax.servlet.*"%>
<%@page import="java.io.File"%>
<%@page import="java.awt.Graphics2D" %>
<%@page import="java.awt.image.BufferedImage" %>
<%@page import="java.io.IOException" %>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.Graphics2D" %>
<%@page import="java.awt.image.BufferedImage" %>
<%@page import="java.io.File" %>
<%@page import="java.io.IOException" %>
<%@page import="javax.imageio.ImageIO" %>
<%@ page import="javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ include file="connnection.jsp"%>
<%!
  public static long resize(File f,String outputImagePath, int scaledWidth, int scaledHeight)throws IOException {
        // reads input image
        File inputFile = f;
        BufferedImage inputImage = ImageIO.read(inputFile);

        // creates output image
        BufferedImage outputImage = new BufferedImage(scaledWidth,scaledHeight, inputImage.getType());

        // scales the input image to the output image
        Graphics2D g2d = outputImage.createGraphics();
        g2d.drawImage(inputImage, 0, 0, scaledWidth, scaledHeight, null);
        g2d.dispose();

        // extracts extension of output file
        String formatName = outputImagePath.substring(outputImagePath
                .lastIndexOf(".") + 1);

        // writes to output file
        ImageIO.write(outputImage, formatName, new File(outputImagePath));
	return inputFile.length();
    }
%>

<%
  String app_id=(String)session.getAttribute("app_id");
  String dob=(String)session.getAttribute("dob");
  response.setContentType("text/html");
  PrintWriter pw=response.getWriter();
  DiskFileItemFactory factory = new DiskFileItemFactory();
  ServletFileUpload sfu  = new ServletFileUpload(factory);
  // parse request
  List items = sfu.parseRequest(request);
  FileItem file1 = (FileItem) items.get(0);
  FileItem file2 = (FileItem) items.get(1);
  String path=request.getRealPath("/img/")+app_id;
  String p=path+"pho.jpg";
  InputStream is=file1.getInputStream();
  File f=new File(p);
  FileOutputStream fout=new FileOutputStream(f);
  while(is.available()>0){
    fout.write((byte)is.read());
  }
  fout.close();
  String s=path+"sig.jpg";
  is=file2.getInputStream();
  f=new File(s);
  fout=new FileOutputStream(f);
  while(is.available()>0){
    fout.write((byte)is.read());
  }
  fout.close();
  
  //Code to resize images
  File photo=new File(path+"pho.jpg");
  File signature=new File(path+"sig.jpg");
  resize(photo,path+"pho.jpg" , 200, 200);//this pic will be saved with appid
  resize(signature,path+"sig.jpg", 300, 100);
 // response.sendRedirect("payment.jsp");//if properly uploaded
%>

