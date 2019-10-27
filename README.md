# Labforward Challenge

- Challenge is a rails application with version 6.0.0, ruby version 2.5.3, and postgres database for identifying sudden peaks in a continuous time series data, so that we can focus on important changes.

- Challenge consists of an api that takes parameters (date_from, date_to, and threshold), to select data points from database as we assumed that the point is entered per day and returns the signals as Zeros and Ones
where Zeros are normal points and Ones are sudden peaks whatever the peak is too high or too low.

- As we are selecting the data points from database so the response of the api will be JSON with two parameters
which are the sample that are selected from database and the output signals in order to know the interval
that we have applied the calculation on.

- Challenge is using RSWAG gem for documenting the apis and allow us to test the apis manually

- Challenge is using active_record and rspec gems for dealing with the database and applying automation test on the syncing service.

- Challenge is using docker and docker-compose to have the best way of running the environments through containers by default.

## Implementation

- For determining the sudden peaks of data points we have to determine the moving zscore and check if it exceeded the threshold or ware below the negative threshold.

- Zscore calculation have the equation of (x-mean)/standard_deviation, But for a moving zscore we have to have a moving window which would be partial from the whole interval and every next point we determine its zscore relative to the current window. (window is assumed to be interval_size / 3).

- At the beginning of the calculation we start with a lag of the interval (assumed to be first two points),
then we determine its mean and standard deviation and then add next points step by step with getting new calculation and every time we reach the window size we start to move the window by shifting it with one element till we reach the end of the interval.

- If we reached a sudden peak we exclude it from the window in order to keep the ratio of normal points and so the next sudden point would still have a high zscore.

- Using a window would be useful to keep the right ratio of normal points in case the interval started with a sudden peak but in this case the peak is a start so it is going to be saved as a normal point (zero) as there is no previous point to be compared with.

## Code Implementation

- I have created a class called NumericArrayCalculation in lib folder which is inherited from Array in order to apply the new calculations to array which are zscore, moving zscore, standard deviation, mean, median.

- As per [this link](https://www.ibm.com/support/knowledgecenter/en/SSEP7J_11.1.0/com.ibm.swg.ba.cognos.ug_ca_dshb.doc/modified_z.html) there is another implementation with the modified zscore which is implemented in the NumericArrayCalculation but this implementation is different from the moving zscore which required in the current challenge and also it depends on a constant approximate standard deviation. it is robust on small interval but might have percentage of error on large interval.

## About Seed Data:

- I have used the data in the excel sheet as seed with applying each point per day starting from the day that seeds run to previous.

- For clarification the saved starting day and ending day will be printed in console after running the seed command

## Prerequisites
- Installing Docker and docker compose
- install ruby version
- pg sql

## Installation and running application

```bash
$ git clone https://github.com/moemenhusseinshaaban/labforward-challenge.git
$ cd PATH_To_LABFORWARD_CHALLENGE/labforward-docker
```

- run `docker-compose build`
- run `docker-compose up -d`
- LABFORWARD_CONTAINER_NAME will always be labforward-docker-web as it is fixed in docker-compose.yml file
- run `docker exec -it labforward-docker-web rails db:create`
- run `docker exec -it labforward-docker-web rake db:migrate`
- run `docker exec -it labforward-docker-web rake db:seed` ==> for applying the seed to database and knowing the starting and ending days of the points
- run `docker exec -it labforward-docker-web rspec` ==> for running test and making sure every thing working fine
- run `docker exec -it labforward-docker-web rails rswag:specs:swaggerize` ==> for creating the rswag json that will be rendered in the browser
- run `docker exec -it labforward-docker-web rails s -b 0.0.0.0` for running rails server
- open http://localhost:3000/api-docs in browser

## Usage

- When opening the application in the browser click on the post api to open the documentation of the api

- Click on the Model link inside the description to see how the model formatted.

- Click on Try it now to start executing the api

- Apply the input body per in mind dates are formatted with "YYYY-MM-DD" and threshold is float

- Click execute to see the response

## Example

- The below JSON codes are just an example for the input/output, so do not expect to have the same response as it is relative to the saved dates when running the seeds

- Input body example:

```
{
  "date_from": "2019-10-10",
  "date_to": "2019-10-10",
  "threshold": 3
}
```

- Response Example:
```
{
  "sample_data_points" => [1, 2, 9, 2, 1],
  "signal" => [0, 0, 1, 0, 0]
}
```

## Test

- Unit test and integration test are applied to the model and the api.

- I have used the sample in the task pdf for applying the integration test.

- To run the test use the command:

```bash
$ docker exec -it labforward-docker-web rspec
```

## Installetion Notes:

- LABFORWARD_CONTAINER_NAME will always be labforward-docker-web as it is fixed in docker-compose.yml file

- Make sure that you are not using the port 3000 in the local device or otherwise change the port of the application of the labforward-docker-web container in docker-compose.yml file

- For production apply the environmental variables of the production database configurations which are:

```bash
PRODUCTION_DB_HOST
PRODUCTION_DB_USERNAME
PRODUCTION_DB_PASSWORD
PRODUCTION_DB_NAME
```

Then run the server using production environment as below:

```bash
$ docker exec -it labforward-docker-web rails s -e production -b 0.0.0.0
```
