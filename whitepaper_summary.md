# Iris Analytics Dashboard — White Paper Summary

## Abstract
This project presents an interactive data analytics dashboard developed using the R Shiny framework. It allows users to visualize, analyze, and manage the classical Iris dataset through a connected SQLite database. The app supports dynamic CRUD (Create, Read, Update, Delete) operations, real-time visualization using Plotly, and provides statistical insights on flower species characteristics.

## Objectives
- To build an interactive Shiny dashboard with database integration.
- To implement CRUD functionality for data management.
- To visualize relationships between Iris flower measurements using Plotly.
- To generate summary statistics and comparative analysis across species.

## Methodology
1. **Dataset:** The built-in `iris` dataset was used, containing measurements of 150 flowers from three species — *Setosa*, *Versicolor*, and *Virginica*.
2. **Database:** A SQLite database (`iris_db.sqlite`) was used to store and modify the dataset dynamically.
3. **Interface:** The UI was developed using `shinydashboard`, featuring sidebar navigation and multiple tabs for different analysis components.
4. **Visualization Tools:** The app uses `plotly` for interactive scatter plots, histograms, boxplots, bar charts, and heatmaps.
5. **CRUD Implementation:** Users can add, update, or delete records directly from the Shiny interface using SQL operations.

## System Architecture
**Frontend:** Shiny + shinydashboard  
**Backend:** SQLite (via RSQLite)  
**Visualization:** Plotly  
**Language:** R  

## Results and Discussion
The developed dashboard enables seamless interaction between users and the dataset. Users can:
- Dynamically modify the dataset using CRUD operations.
- Observe visual trends between sepal and petal dimensions.
- Compare species characteristics via boxplots and grouped bar charts.
- Analyze correlations between measurements through heatmaps.

The application demonstrates real-time interactivity, efficient data management, and aesthetic visual presentation, suitable for data analytics tasks and educational demonstrations.

## Conclusion
The Iris Analytics Dashboard successfully integrates database operations with Shiny-based visualization. It serves as a model for building data-driven R applications that combine analytics, interactivity, and persistent data management.

## References
- RStudio Documentation: [https://shiny.rstudio.com](https://shiny.rstudio.com)
- Plotly for R: [https://plotly.com/r/](https://plotly.com/r/)
- Wickham, H. (2016). *ggplot2: Elegant Graphics for Data Analysis.* Springer.
